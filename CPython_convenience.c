#include <Python.h>

short dict_to_short(PyObject *dict, char key[])
{
  return (short)PyInt_AsLong(PyDict_GetItemString(dict, key));
}

int dict_to_int(PyObject *dict, char key[])
{
  return (int)PyInt_AsLong(PyDict_GetItemString(dict, key));
}

long dict_to_long(PyObject *dict, char key[])
{
  return PyInt_AsLong(PyDict_GetItemString(dict, key));
}

double dict_to_double(PyObject *dict, char key[])
{
  return PyFloat_AsDouble(PyDict_GetItemString(dict, key));
}
