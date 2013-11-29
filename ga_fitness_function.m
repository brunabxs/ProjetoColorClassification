function result = ga_fitness_function(genome, training_set)
    rule = create_rule(genome, training_set);
    
    % encontra quais as instancias de treinamento que foram classificadas 
    % (ou nao) como a regra
    training_set_class_rule_matches = find([training_set(:).class] == rule.class);
    training_set_class_rule_nomatches = find([training_set(:).class] ~= rule.class);
    
    % encontra os pesos das instancias de treinamento classificadas (ou nao) como a
    % regra
    w_matches = [training_set(training_set_class_rule_matches).w]';
    w_nomatches = [training_set(training_set_class_rule_nomatches).w]';
    
    % encontra o valor da regra das instancias de treinamento classificadas 
    % (ou nao) como a regra    
    mu_matches = rule.mu(training_set(training_set_class_rule_matches));
    mu_nomatches = rule.mu(training_set(training_set_class_rule_nomatches));
    
    % numero de instâncias de treinamento cobertas pela regra Ri
    % comparada com o numero de instâncias de treinamento que são da classe
    % ci
    n = sum(w_matches .* mu_matches) / sum(w_matches);
    f1 = n;
    
    result = f1;
end