from user_mgmt.models import Role
from django import forms
from django.contrib.auth import get_user_model
from django.utils.translation import gettext as _
from django.contrib.auth.password_validation import validate_password
from django.forms import EmailField, CharField, NumberInput
from django.core.exceptions import ValidationError
from django.core.validators import RegexValidator


User = get_user_model()
PROVINCE_MINISTRY_ROLE = "province_ministry_user"


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
    user_role = forms.ChoiceField(required=False)

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
        role_choices = [("", "छान्नुहोस्...")]
        role_choices.extend((str(role.pk), str(role)) for role in Role.objects.all())
        role_choices.append((PROVINCE_MINISTRY_ROLE, "प्रदेश मन्त्रालय प्रयोगकर्ता"))
        self.fields["user_role"].choices = role_choices

        if instance and instance.pk and instance.level and instance.level.type.type == "P":
            self.fields["user_role"].initial = (
                str(instance.roles.first().pk) if instance.roles.exists() else PROVINCE_MINISTRY_ROLE
            )

    def clean(self):
        cleaned_data = super().clean()
        level = cleaned_data.get("level")
        role_value = cleaned_data.get("user_role")

        if level and level.type.type == "P" and not role_value:
            self.add_error("user_role", "प्रयोगकर्ताको भूमिका आवश्यक छ।")

        return cleaned_data


    def save(self, commit=True):
        u = super().save(commit=commit)
        role_value = self.cleaned_data.get("user_role")

        if role_value == PROVINCE_MINISTRY_ROLE:
            u.roles.clear()
        elif role_value:
            u.roles.set([Role.objects.get(pk=role_value)])
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
