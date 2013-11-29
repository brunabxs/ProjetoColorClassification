function result = ga_fitness_function(genome, training_set)
    rule = create_rule(genome, training_set);
    
    % encontra quais as instancias de treinamento que foram classificadas 
    % (ou nao) como a regra
    training_set_class_rule_matches = find([training_set(:).class] == rule.class);
    training_set_class_rule_nomatches = find([training_set(:).class] ~= rule.class);
    
    % encontra os pesos das instancias de treinamento classificadas (ou nao) como a
    % regra
    w = [training_set(:).w];
    w_matches = [training_set(training_set_class_rule_matches).w]';
    w_nomatches = [training_set(training_set_class_rule_nomatches).w]';
    
    % encontra o valor da regra das instancias de treinamento classificadas 
    % (ou nao) como a regra    
    mu_matches = rule.mu(training_set(training_set_class_rule_matches));
    mu_nomatches = rule.mu(training_set(training_set_class_rule_nomatches));
    
    % numero de instancias de treinamento cobertas pela regra Ri
    % comparada com o numero de instancias de treinamento que sao da classe
    % ci
    n = sum(w_matches .* mu_matches) / sum(w_matches);
    f1 = n;
    
    % fracao das instancias cobertas pela regra Ri independente da classe
    % a regra deve ser geral o suficiente de maneira que cubra uma fracao
    % significante (kcov) de todas as instancias ao inves de representar
    % outliers no conjunto de treinamento
    n = sum(w_matches .* mu_matches) / sum(w);
    kcov = 0.8;
    f2 = 1 * (n > kcov) + (n/kcov) * (n <= kcov);
    
    result = f1 * f2;
end