function rule = create_rule(genome, training_set)
    attributes_size = numel(genome) / 5;
    A = genome(1 : 4*attributes_size);
    S = genome(4*attributes_size+1 : 5*attributes_size);
    
    rule = struct('A', A, 'S', S, 'mf', get_parameters(A), 'mu', @(set) mu(A, S, set), 'class', rule_class(A, S, training_set), 'error', inf);
end

function result = rule_class(A, S, training_set)
    num_classes = max([training_set(:).class]);
    classes = zeros(1, num_classes);

    % encontra os graus de pertinencia de cada instancia de treinamento
    mu_training_set = mu(A, S, training_set);
    
    % para cada classe, calcula a soma dos graus de pertinencia das
    % instancias desta classe
    for i = 1 : numel(classes);
        positions = find([training_set(:).class] == i);
        classes(i) = sum(mu_training_set(positions));
    end
    
    % encontra a classe que possui a maior soma
    [~, max_pos] = max(classes);
    result = max_pos;
end

function result = mu(A, S, set)
    attributes_size = numel(A) / 4;
    result = arrayfun(@(instance) min(arrayfun(@(i) eval(instance.attributes(i), get_function(A, i)), 1 : attributes_size)), set);
end

function result = get_function(A, i)
    result = A((i-1)*4 + 1 : i*4);
end

function result = eval(attribute, A)
    result = trapmf(attribute, get_parameters(A));
end

function result = get_parameters(A)
    a = A(1);
    b = a + A(2);
    c = b + A(3);
    d = c + A(4);
    result = [a b c d];
end