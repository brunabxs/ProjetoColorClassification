function population = ga_creation_function(genome_length, fitness_function, options, training_set)
    population = ones(options.PopulationSize, genome_length);
    
    probabilities = cumsum([training_set(:).w]);
    probabilities = probabilities / max(probabilities);

    for i = 1 : options.PopulationSize
        % escolhe individuos do conjunto de treinamento
        x1 = get_training_instance(training_set, probabilities);
        x2 = get_training_instance(training_set, probabilities);

        % cria o cromossomo
        genome = create_genome(x1, x2);
        
        % insere o individuo na populacao
        population(i, :) = genome;
    end
end

function genome = create_genome(instance1, instance2)
    attributes = [instance1.attributes; instance2.attributes];
    s = ones(1, size(attributes, 2));
    genome = [ones(1, 4 * size(attributes, 2)) s];
    
    for i = 1 : size(attributes, 2)
        genome(1, (i-1)*4 + 1 : (i-1)*4 + 4) = create_genome_part(attributes(1, i), attributes(2, i));
    end
end

function part = create_genome_part(attribute1, attribute2)
    b = min(attribute1, attribute2);
    c = max(attribute1, attribute2);
    a = b - abs(attribute1 - attribute2) / 2;
    d = c + abs(attribute1 - attribute2) / 2;
    delta1 = b - a;
    delta2 = c - b;
    delta3 = d - c;
    
    part = [a, delta1, delta2, delta3];
end

function training_instance = get_training_instance(training_set, likelihood)
    x = rand;
    for i = 1 : numel(likelihood)
        if likelihood(i) > x
            training_instance = training_set(i);
            break;
        end
    end
end