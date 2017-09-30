from distutils.core import setup, Extension
# sets up mag_engine.c so that it's functions are accessible from the Python
# module mag_engine once $ python setup.py install  has been run as root.

setup( name = 'mag_engine', verion = '0.1',
    ext_modules = [ Extension('mag_engine', ['mag_engine.c']) ] )
