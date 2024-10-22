"""
Test custom Django management commands
"""

from unittest.mock import patch

from psycopg2 import OperationalError as Psycog2Error

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase

@patch('core.management.command.eait_for_db.Command.check')
class CommandTest(SimpleTestCase):
    """Test Commands"""

    def test_wait_for_db_ready(self, pathced_check):
        """Test eaiting for database if database ready."""
        patched_Check.return_calue = True

        call_command('wait_for_db')

        patched_check.assert_called_once_with(database=['default'])