#include <Python.h>

static PyObject *add(PyObject *self, PyObject *args)
{
  int a, b, c;

  // make sure function arguments are correct or return NULL pointer
  if (!PyArg_ParseTuple(args, "ii", &a, &b)){
    return NULL;
  }
  c = a + b;

  // convert c back into a python type integer
  return Py_BuildValue("i", c);
}

static char addition_docs[] = "Testing basic arithmetic";

static PyMethodDef mag_engine_funcs[] = {
  {"add", (PyCFunction)add, METH_VARARGS, addition_docs},
  {NULL}
};

void initmag_engine(void)
{
  Py_InitModule3("mag_engine", mag_engine_funcs,
    "library for python micromagnetism project");
}
