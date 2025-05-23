import csv
import matplotlib.pyplot as plot
import numpy

data = {
}

with open('SAT.csv') as file:
    for [problem, solver, n, time, *rest] in csv.reader(file):
        data[problem][solver][n] = time

numpy.mean(data)

plot.figure(figsize=(6, 3))

# problem = data['cards']
for (solver, results) in data['cards']:
    # plot.figure(figsize=(5,3))
    # plot.figure(figsize=(5,3))
    # plot.figure(figsize=(5,3))
    _, ax = plot.subplots()
    # color = ax._get_lines.get_next_color()

    # plot.plot(x_coords, y_coords_mean, label=f'{solver} time', linewidth=1.2)
