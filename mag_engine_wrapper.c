#include <Python.h>
#include "mag_engine.h"

static char addition_docs[] = "Testing basic arithmetic. Adds two ints.";
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


// Calls the functions sitting in engine.c. Initializes variables in vars.c.
static char reduce_energy_docs[] = "Reduces the energy of the spin system by\
  randomly kicking spins size times.";
static PyObject *reduce_energy(PyObject *self, PyObject *args)
{
  get_parameters();
  get_variables();
  double the_test = T[0][0];
  printf("The test: %f\n", the_test);
  
  return Py_BuildValue("d", T[0][0]);
}


// Describe which functions will be accessible from python.
static PyMethodDef mag_engine_funcs[] = {
  {"add", (PyCFunction)add, METH_VARARGS, addition_docs},
  {"reduce_energy", (PyCFunction)reduce_energy, METH_NOARGS,
  reduce_energy_docs},
  {NULL}
};

// initialize the module
void initmag_engine(void)
{
  Py_InitModule3("mag_engine", mag_engine_funcs,
    "library for python micromagnetism project");
}
