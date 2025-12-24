from django import forms

from core.models import CentralBody, ProvinceBody, LocalBody

from user_mgmt.models import Level, LevelType

class ProvinceLevelEntitiesForm(forms.ModelForm):
    class Meta:
        model = ProvinceBody
        fields = ["name_np"]



class LevelForm(forms.ModelForm):
    class Meta:
        model = Level
        fields = ('name', 'province_level', 'district', 'level_code')
    
    def __init__(self, *args, **kwargs):
        super(LevelForm, self).__init__(*args, **kwargs)
        self.fields['province_level'].empty_label = "Select"
        self.fields['district'].empty_label = "Select"
        self.fields['level_code'].required=True