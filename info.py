import matplotlib.pyplot as plt
import numpy as np
from ipywidgets import IntSlider, interact
from mpl_toolkits.mplot3d import Axes3D


# Define the rose function
def rose(theta, k):
    r = np.cos(k * theta)
    x = r * np.cos(theta)
    y = r * np.sin(theta)
    return x, y


# Plot the rose function
def plot_rose(k):
    theta = np.linspace(0, 2 * np.pi, 400)
    x, y = rose(theta, k)

    # Create a figure
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(x, y)
    ax.set_aspect('equal')
    plt.show()


# Create an interactive plot with a slider for the number of petals
interact(plot_rose, k=IntSlider(min=1, max=10, step=1, value=1))
