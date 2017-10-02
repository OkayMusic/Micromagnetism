import time
import matplotlib
matplotlib.use('GTKAgg')
import numpy as np
import scipy as sp
import tensorflow as tf
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from mpl_toolkits.mplot3d import Axes3D
from numpy.random import rand, randint
from scipy.fftpack import fft, ifft

import mag_engine

# GLOBAL STUFF
parameters = {'dimension':1, 'size':2**2, 'stiff_const':-1, 'dm_const':0.,
    'boundary':0., 'b_field':[0, 0, 1.], 'temperature':0.001, 'surf_const':0.,
    'Lambda':30., 'alpha':48.*np.pi/180.}

variables = {'T':0, 'P':0, 'X':0, 'Y':0, 'Z':0}

# Define global lists which will contain the list versions of T & P for c.
c_T = []; c_P = [];

plotters = {'background':0, 'qui':0, 'surf':0}

def get_parameter_list():
    a = [parameters[keys] for keys in parameters]
    b = [variables[keys] for keys in variables]
    for elements in b:
        a.append(elements)
    return a

def make_grid():
    size = parameters['size']
    try:
        if parameters['dimension'] == 2:
            size = int(np.sqrt(size))
            return np.meshgrid(range(size), range(size), 0)
        elif parameters['dimension'] == 1:
            return np.meshgrid(range(size), 0, 0)
    except:
        print("Dimension error")

def rand_spins():
    # returns theta, phi
    size = parameters['size']
    try:
        if parameters['dimension'] == 2:
            size = int(np.sqrt(size))
            return np.pi*rand(size, size), 2*np.pi*rand(size, size)
        elif parameters['dimension'] == 1:
            return np.pi*rand(size, 1), 2*np.pi*rand(size, 1)
    except:
        print("Dimension error")

def sph_to_cart():
    # returns Mx, My, Mz
    theta = variables['T']
    phi = variables['P']
    return np.sin(theta)*np.cos(phi), np.sin(theta)*np.sin(phi), np.cos(theta)

def array_to_list():
    global c_T
    global c_P
    c_T = [list(x) for x in variables['T']]
    c_P = [list(x) for x in variables['P']]

def wiggle(a, b):
    theta, phi = variables['T'], variables['P']
    E_0 = local_energy(a,b)
    theta_ab_0 = theta[a,b]
    phi_ab_0 = phi[a,b]

    delta = np.pi*rand()/2 - np.pi/4
    if rand() > parameters['temperature']:
        if rand() < 0.5:
            theta[a,b] += delta/2
        else:
            phi[a,b] += delta
        E_new = local_energy(a, b)
        if E_new < E_0:
            return theta[a,b], phi[a,b]
        else:
            return theta_ab_0, phi_ab_0
    else:
        return np.pi*rand(), 2*np.pi*rand()

def local_energy(a, b):
    theta, phi = variables['T'], variables['P']
    Mx, My, Mz = sph_to_cart()
    vol = Mx.shape
    # nested energy functions
    def exchange(a, b, c, d):
        return parameters['stiff_const'] * (
        (Mx[a,b] - Mx[c,d])**2 +
        (My[a,b] - My[c,d])**2 +
        (Mz[a,b] - Mz[c,d])**2 )
    def dm(a, b, c ,d):
        return parameters['dm_const'] * np.dot(
        np.array([Mx[a,b], My[a,b], Mz[a,b]]),
        np.array([
        Mz[a,b]-Mz[c,b], -Mz[a,b]+Mz[a,d], -Mx[a,b]+My[a,b]+Mx[c,b]-My[a,d]]) )
    def zeeman(a, b):
        return np.dot(
        np.array(parameters['b_field']), np.array([Mx[a,b],My[a,b],Mz[a,b]]) )
    def surf_anisotropy(a, b):
        return parameters['surf_const'] * Mx[a,b]**2

    energy = zeeman(a,b) + surf_anisotropy(a,b)
    if parameters['boundary'] == 0:
        if a != 0:
            energy += exchange(a,b,a-1,b) + dm(a,b,a-1,b)
        if a != vol[0]-1:
            energy += exchange(a+1,b,a,b) + dm(a+1,b,a,b)
        if b != 0:
            energy += exchange(a,b,a,b-1) + dm(a,b,a,b-1)
        if b != vol[1]-1:
            energy += exchange(a,b+1,a,b) +  dm(a,b+1,a,b)
    elif parameters['boundary'] == 1:
        if a != 0:
            energy += exchange(a,b,a-1,b) + dm(a,b,a-1,b)
        else:
            energy += exchange(a,b,-1,b) + dm(a,b,-1,b)
        if b != 0:
            energy += exchange(a,b,a,b-1) + dm(a,b,a,b-1)
        else:
            energy += exchange(a,b,a,-1) + dm(a,b,a,-1)
    return energy

def init_plot():
    Mx, My, Mz = sph_to_cart()

    fig = plt.figure()
    ax = fig.add_subplot(111)

    plotters['qui'] = ax.quiver(Mx, My, color = '#220c5f')
    if parameters['dimension'] == 2:
        plotters['surf'] = ax.imshow(Mz, cmap = 'spring', alpha = 0.5,
            interpolation = 'gaussian')
    plotters['background'] = fig.canvas.copy_from_bbox(ax.bbox)

    fig.show()
    fig.canvas.draw()

def update_plot():
    Mx, My, Mz = sph_to_cart()

    fig = plt.gcf()
    ax = fig.add_subplot(111)

    fig.canvas.restore_region(plotters['background'])
    if parameters['dimension'] == 2:
        plotters['surf'].set_data(Mz)
        ax.draw_artist(plotters['surf'])
    plotters['qui'].set_UVC(Mx, My)

    ax.draw_artist(plotters['qui'])

    fig.canvas.blit(ax.bbox)

def reduce_energy():
    t1 = time.clock()
    size = parameters['size']
    theta, phi = variables['T'], variables['P']
    try:
        side = int(np.sqrt(size))
    except:
        pass
    for sites in range(size):
        if parameters['dimension'] == 2:
            x, y = randint(side), randint(side)
            theta[x,y], phi[x,y] = wiggle(x, y)
        elif parameters['dimension'] == 1:
            x, y = randint(size), 0
            theta[x,y], phi[x,y] = wiggle(x, y)
    print("calculation time:", time.clock() - t1)
    t1 = time.clock()
    update_plot()
    print("drawing time:",time.clock() - t1)

def main_loop(iterations):
    for i in range(iterations):
        reduce_energy()
    # plt.show()

def intensity(q):
    Mx, My, Mz = sph_to_cart()
    exp_list = np.array([np.exp for x in Mx])
    def damp_func():
        return 1/(parameters['Lambda']) * np.exp( -2/(parameters['Lambda'] *
            np.cos(parameters['alpha'])) * variables['X'])

    Y = damp_func()

    amplitude1 = np.sum( Mz * np.exp(1j*q*variables['X']))
    amplitude2 = np.sum( Y * amplitude1 )

    intensity2 = np.absolute(amplitude2)**2
    return intensity2

def plot_ft():
    Mx, My, Mz = sph_to_cart()

    def my_ft(q):
        return np.sum(Mz*np.exp(1j*q*np.array(range(parameters['size']))))

    print(my_ft(1))

    q_range = np.linspace(0, parameters['size'], parameters['size']*20)
    q_list = [np.absolute(my_ft(q))**2 for q in q_range]

    plt.figure()

    plt.plot(q_range, q_list)

    plt.show()

if __name__ == "__main__":
    variables['X'], variables['Y'], variables['Z'] = make_grid()
    variables['T'], variables['P'] = rand_spins()

    array_to_list()
    print(c_T)
    # iterations = 5000
    #
    # init_plot()
    #
    # main_loop(iterations)
    print(mag_engine.reduce_energy())
