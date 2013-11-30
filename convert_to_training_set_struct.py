def get_attributes(line, attributes):
    string = []
    values = line.split(',')
    values = values[1 : len(attributes)+1]
    for attribute, value in zip(attributes, values):
        string.append("'" + attribute + "' : " + value)
    return ', '.join(string)[:-1]

def get_class(line, classes):
    string = []
    values = line.split(',')
    value = values[0]
    return "'class' : " + str(classes.index(value))
    
def get_likelihood():
    return "'w' : 0"
    
if __name__ == '__main__':
    fileUCI = open('uci.data')
    lines = fileUCI.readlines()
    fileUCI.close()
    
    fileMATLAB = open('matlab.data', 'w')
    fileMATLAB.write('training_set = [\n')
    for line in lines:
        string = 'struct(' + get_attributes(line, ['lw', 'ld', 'rw', 'rd']) + ', ' + get_class(line, ['R', 'B', 'L']) + ', ' + get_likelihood() + '); \n'
        fileMATLAB.write(string)
    fileMATLAB.write('];\n')
    fileMATLAB.close()