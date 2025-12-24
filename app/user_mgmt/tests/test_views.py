from django.contrib.auth import get_user_model
from django.test import TestCase
from django.urls import reverse

from user_mgmt.models import Role

User = get_user_model()


class RolesTestCase(TestCase):
    fixtures = ['user_mgmt/fixtures/test_fixtures.json']

    def test_role_create(self) -> None:
        url = reverse('user_mgmt:role_create')
        data = {
            'name': "Admin",
            'menus': [1, 2]
        }
        response = self.client.post(url, data)

        # test if it properly redirects to the success url after create
        self.assertRedirects(response, reverse('user_mgmt:role_list'))

        # test if menus are properly added in the role
        role = Role.objects.get(name="Admin")
        self.assertEqual(role.menus.all().count(), 2)

    def test_role_list(self) -> None:
        url = reverse('user_mgmt:role_list')
        response = self.client.get(url)

        # test if correct template is being used
        self.assertTemplateUsed(response, 'user_mgmt/role_list.html')

        # test response status code is OK
        self.assertEqual(response.status_code, 200)
