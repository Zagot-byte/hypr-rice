#!/usr/bin/env bash
# ── Rofi Calculator ──────────────────────────────────
# Supports: basic math, power, sqrt, sin/cos/tan,
#           integration (quad), differentiation (diff),
#           constants (pi, e)

if [[ -z "$*" ]]; then
    echo "e.g: 2^8 | sqrt(16) | sin(pi/2) | diff(x^2,x) | integrate(x^2,0,1)"
    exit 0
fi

python3 - "$*" << 'EOF'
import sys
import math
from sympy import *

x, y, z = symbols('x y z')

# Safe namespace
ns = {
    # sympy
    'x': x, 'y': y, 'z': z,
    'diff': diff,
    'integrate': integrate,
    'sqrt': sqrt,
    'sin': sin, 'cos': cos, 'tan': tan,
    'asin': asin, 'acos': acos, 'atan': atan,
    'log': log, 'exp': exp,
    'pi': pi, 'e': E,
    'simplify': simplify,
    'expand': expand,
    'factor': factor,
    'limit': limit,
    'Matrix': Matrix,
    # power operator
    '__builtins__': {}
}

expr = sys.argv[1].replace('^', '**')

try:
    result = eval(expr, ns)
    result = simplify(result)
    print(str(result))
    # also copy to clipboard
    import subprocess
    subprocess.run(['wl-copy'], input=str(result).encode())
except Exception as ex:
    print(f"Error: {ex}")
EOF
