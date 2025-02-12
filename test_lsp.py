# test_python.py
import os  # unused import (should trigger F401)
from typing import Optional

def greet(name: Optional[str] = None) -> str:
    if name is None:
        return "Hello, World!"
    return f"Hello, {name}!"

def unused_function():  # unused function (should trigger pyright hint)
    pass

x = 10  # unused variable (should trigger F841)
x = 20  # shadowed variable (should trigger ruff warning)

# Incorrect type hint (should trigger pyright error)
def add(a: int, b: int) -> str:
    return a + b

# Unhandled exception (should trigger ruff warning)
def divide(a: int, b: int) -> float:
    return a / b

# Incorrect time format (should trigger ruff warning)
from datetime import datetime
print(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))  # correct
print(datetime.now().strftime("%Y/%m/%d"))  # incorrect

# Unused class (should trigger pyright hint)
class UnusedClass:
    pass
