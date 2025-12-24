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
        phone_validator = RegexValidator('^(\+\d{1,3}[- ]?)?\d{10}$', 
            message="Invalid Phone Number. Please enter Phone number as Landline Area Code with 9-10 digit or Mobile number of 10 digit within 0-9 ") 

        for field in self.fields:
            self.fields[field].help_text = None
            self.fields[field].widget.attrs.update({'class': 'form-control'})
            self.fields['mobile_num'] = CharField(widget=NumberInput, validators=[phone_validator], required=True, max_length=10)


    def save(self, commit=True):
        u = super().save(commit=commit)
        role = self.cleaned_data.get("user_role")
        if role:
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