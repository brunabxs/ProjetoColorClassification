function rule = create_rule(genome, training_set)
    A = genome(1:12);
    S = genome(13:15);
    rule = struct('A', A, 'S', S, 'mf', get_parameters(A), 'mu', @(instance) mu(A, S, instance), 'class', @() rule_class(A, S, training_set));
end

function result = rule_class(A, S, training_set)
    num_classes = max([training_set(:).class]);
    classes = zeros(1, num_classes);

    for i = 1 : numel(training_set);
        training_instance = training_set(i);
        classes(training_instance.class) = classes(training_instance.class) + mu(A, S, training_instance);
    end
    
    [~, max_pos] = max(abs(classes));
    result = max_pos;
end

function result = mu(A, S, instance)
    A1 = A(1:4);
    A2 = A(5:8);
    A3 = A(9:12);
    
    muA1 = evalmmf(instance.r, get_parameters(A1), 'trapmf');
    muA2 = evalmmf(instance.g, get_parameters(A2), 'trapmf');
    muA3 = evalmmf(instance.b, get_parameters(A3), 'trapmf');
    
    result = min([muA1, muA2, muA3]);
end

function result = get_parameters(A)
    a = A(1);
    b = a + A(2);
    c = b + A(3);
    d = c + A(4);
    result = [a b c d];
end