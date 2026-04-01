from user_mgmt.models import Role
from django import forms
from django.contrib.auth import get_user_model
from django.utils.translation import gettext as _
from django.contrib.auth.password_validation import validate_password
from django.forms import EmailField, CharField, NumberInput
from django.core.exceptions import ValidationError
from django.core.validators import RegexValidator


User = get_user_model()


class UserLoginForm(forms.Form):
    password = forms.CharField(widget=forms.PasswordInput)
    email = forms.EmailField()


class SetNewStaffPasswordForm(forms.Form):  
    new_password1 = forms.CharField(
        widget=forms.PasswordInput, validators=[validate_password]
    )
    new_password2 = forms.CharField(widget=forms.PasswordInput)

    def clean_new_password2(self):
        password1 = self.cleaned_data.get("new_password1")
        password2 = self.cleaned_data.get("new_password2")
        if password1 and password1 != password2:
            raise forms.ValidationError(_("Sorry the two passwords didn't match."))
        return password2


class UserSetupForm(forms.ModelForm):
    user_role = forms.ModelChoiceField(queryset=Role.objects.all(), required=False)
    account_type = forms.ChoiceField(
        choices=(
            ("dashboard_user", "प्रदेश ड्यासबोर्ड प्रयोगकर्ता"),
            ("province_ministry_user", "प्रदेश मन्त्रालय प्रयोगकर्ता"),
        ),
        required=False,
    )

    class Meta:
        model = User
        fields = [
            "full_name",
            "email",
            "mobile_num",
            "designation",
            "user_role",
            "personal_email",
            "department",
            "level",
            "post",
            "is_active",
        ]
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        phone_validator = RegexValidator(r'^(\+\d{1,3}[- ]?)?\d{10}$', 
            message="Invalid Phone Number. Please enter Phone number as Landline Area Code with 9-10 digit or Mobile number of 10 digit within 0-9 ") 

        for field in self.fields:
            self.fields[field].help_text = None
            self.fields[field].widget.attrs.update({'class': 'form-control'})
            self.fields['mobile_num'] = CharField(widget=NumberInput, validators=[phone_validator], required=True, max_length=10)

        instance = kwargs.get("instance")
        if instance and instance.pk and instance.level and instance.level.type.type == "P":
            self.fields["account_type"].initial = (
                "dashboard_user" if instance.roles.exists() else "province_ministry_user"
            )
        else:
            self.fields["account_type"].initial = "dashboard_user"

    def clean(self):
        cleaned_data = super().clean()
        level = cleaned_data.get("level")
        account_type = cleaned_data.get("account_type") or "dashboard_user"
        role = cleaned_data.get("user_role")

        if level and level.type.type == "P" and account_type == "dashboard_user" and not role:
            self.add_error("user_role", "ड्यासबोर्ड प्रयोगकर्ताका लागि भूमिका आवश्यक छ।")

        return cleaned_data


    def save(self, commit=True):
        u = super().save(commit=commit)
        role = self.cleaned_data.get("user_role")
        account_type = self.cleaned_data.get("account_type") or "dashboard_user"

        if account_type == "province_ministry_user":
            u.roles.clear()
        elif role:
            u.roles.set([role])
        else:
            u.roles.clear()
        return u



class PasswordResetRequestForm(forms.Form):
    email = EmailField(required=True)

    def clean_email(self):
        cleaned_data = super().clean()
        current_email = cleaned_data.get('email')
        exists = User.objects.filter(email=current_email)
        if not exists:
            raise forms.ValidationError("Email not registered!")
        return current_email

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields:
            self.fields[field].help_text = None
            self.fields[field].widget.attrs.update({'class': 'form-control'})
