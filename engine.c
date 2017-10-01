#include <Python.h>
#include <math.h>
#include "mag_engine.h"

// Gets the python dictionary containing the variables, parses through the items
// in the dict, and appropriately assignes their values to the corresponding c
// variables.
void get_variables(void)
{
  PyObject *PyMain = PyImport_AddModule("__main__");
  PyObject *dict   = PyObject_GetAttrString(PyMain, "variables");

  PyObject *theta_list = PyDict_GetItemString(dict, "T");
  PyObject *phi_list = PyDict_GetItemString(dict, "P");
  // theta_list = PyList_GetItem(theta_list, 0);
  // phi_list = PyList_GetItem(phi_list, 0);

  switch(dimension){
    case 1:
      T  = malloc(size * sizeof(double));
      *T = malloc(sizeof(double));
      P  = malloc(size * sizeof(double));
      *P = malloc(sizeof(double));
      for (int i = 0; i < size; i++){
        T[0][i] = PyFloat_AsDouble((PyList_GetItem(theta_list, i)));
        P[0][i] = PyFloat_AsDouble((PyList_GetItem(phi_list, i)));
        printf("%f\n", P[0][i]);
      }

    case 2:
      size = sqrt(size);
      T  = malloc(size * sizeof(double));
      *T = malloc(size * sizeof(double));
      P  = malloc(size * sizeof(double));
      *P = malloc(size * sizeof(double));
      for (int i = 0; i < size; i++){
        for (int j = 0; j < size; j++){
          T[0][0]=1;
          P[0][0]=1;
        }
      }

  }
}


// Gets the python dictionary containing the parameters, parses through the
// items in the dict, and appropriately assignes the values to the corresponding
// c variables. As the system parameters are constant throughout the simulation,
// this needs to only be called once.
void get_parameters(void)
{
  PyObject *PyMain = PyImport_AddModule("__main__");
  PyObject *dict   = PyObject_GetAttrString(PyMain, "parameters");

  dimension   = dict_to_short(dict, "dimension");
  size        = dict_to_short(dict, "size");
  stiff_const = dict_to_double(dict, "stiff_const");
  dm_const    = dict_to_double(dict, "dm_const");
  boundary    = dict_to_short(dict, "boundary");
  temperature = dict_to_double(dict, "temperature");
  surf_const  = dict_to_double(dict, "surf_const");
  Lambda      = dict_to_double(dict, "Lambda");
  alpha       = dict_to_double(dict, "alpha");

  PyObject *b_field = PyDict_GetItemString(dict, "b_field");
  b_field_x = PyFloat_AsDouble(PyList_GetItem(b_field, 0));
  b_field_y = PyFloat_AsDouble(PyList_GetItem(b_field, 1));
  b_field_z = PyFloat_AsDouble(PyList_GetItem(b_field, 2));
}
