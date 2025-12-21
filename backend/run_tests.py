# run_tests.py (in backend root)
#!/usr/bin/env python3
"""Run all tests for the Vestium backend"""
import sys
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

print("🧪 Running Vestium Backend Tests")
print("=" * 60)

# Check if we're in the right directory
if not os.path.exists('tests'):
    print("❌ 'tests' directory not found. Are you in the backend root?")
    sys.exit(1)

# Run pytest
import pytest

# Run tests with specific markers or all
result = pytest.main([
    'tests/',
    '-v',  # verbose
    '--tb=short',  # shorter traceback
    '-W', 'ignore::DeprecationWarning',  # ignore warnings
])

if result == 0:
    print("\n✅ All tests passed!")
else:
    print(f"\n❌ Some tests failed (exit code: {result})")
    sys.exit(result)