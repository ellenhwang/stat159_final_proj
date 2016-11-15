import numpy as np
import matplotlib.pyplot as plt

with open("MERGED2014_15_PP.csv", 'r') as fin:
    count = 0
    null_counts = np.zeros(len(fin.readline().split(",")))

    for line in fin:

        clean = line.split('"')
        if len(clean) != 1:
            clean[1] = 'NULL'
            line = '"'.join(clean)

        vals = np.array(line[:-1].split(','))
        null_counts += vals == 'NULL'

        count += 1

    keep = null_counts < count * 0.99


with open("MERGED2014_15_PP.csv", 'r') as fin:
    with open("cleaned_data", 'w') as fout:

        vals = np.array(fin.readline()[:-1].split(','))

        fout.write(vals[0])
        for i in range(1, len(vals)):
            if keep[i]:
                fout.write(",{0}".format(vals[i]))

        fout.write("\n")

        count = 0

        for line in fin:

            clean = line.split('"')
            if len(clean) != 1:
                clean[1] = 'NULL'
                line = '"'.join(clean)

            vals = np.array(line[:-1].split(','))

            fout.write(vals[0])
            for i in range(1, len(vals)):
                if keep[i]:
                    fout.write(",{0}".format(vals[i]))

            fout.write("\n")

            count += 1

            print(count)
