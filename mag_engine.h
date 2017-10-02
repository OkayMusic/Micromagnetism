#ifndef memes
#define memes

void get_variables(void);
void get_parameters(void);

short dict_to_short(PyObject *dict, char key[]);
int dict_to_int(PyObject *dict, char key[]);
long dict_to_long(PyObject *dict, char key[]);
double dict_to_double(PyObject *dict, char key[]);
double list_2d_to_double(PyObject *list, int i, int j);

extern short dimension;
extern short size;
extern double stiff_const;
extern double dm_const;
extern short boundary;
extern double temperature;
extern double surf_const;
extern double Lambda;
extern double alpha;

extern double b_field_x;
extern double b_field_y;
extern double b_field_z;

extern double** T;
extern double** P;

extern double a;

#endif
