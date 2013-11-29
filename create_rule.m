function rule = create_rule(genome, training_set)
    A = genome(1:12);
    S = genome(13:15);
    rule = struct('A', A, 'S', S, 'mf', get_parameters(A), 'mu', @(set) mu(A, S, set), 'class', rule_class(A, S, training_set));
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
        mu_training_set(positions);
        classes(i) = sum(mu_training_set(positions));
    end
    
    % encontra a classe que possui a maior soma
    [~, max_pos] = max(classes);
    result = max_pos;
end

function result = mu(A, S, set)
    A1 = A(1:4);
    A2 = A(5:8);
    A3 = A(9:12);
    
    result = arrayfun(@(instance) min([eval(instance.r, A1), eval(instance.g, A2), eval(instance.b, A3)]), set);
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