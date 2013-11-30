function result = ga_fitness_function(genome, training_set)
    rule = create_rule(genome, training_set);
    
    % encontra quais as instancias de treinamento que foram classificadas 
    % (ou nao) como a regra
    training_set_class_rule_matches = find([training_set(:).class] == rule.class);
    training_set_class_rule_nomatches = find([training_set(:).class] ~= rule.class);
    
    % encontra os pesos das instancias de treinamento classificadas (ou nao) como a
    % regra
    w = [training_set(:).w]';
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
    
    % consistencia requer que a regra cubra varias instancias corretas e um
    % pequeno grupo de incorretas. A avaliacao da k-consistencia de uma
    % regra e definida pela razao destes numeros.
    % k ([0, 1]) determina a tolerancia maxima para o erro cometido por uma
    % regra (individualmente).
    n_plus = sum(w_matches .* mu_matches);
    n_minus = sum(w_nomatches .* mu_nomatches);
    k = 2;
    f3 = 0 * (n_plus * k < n_minus) + ((n_plus - (n_minus / k)) / n_plus) * (n_plus * k >= n_minus);
    
    % para problemas com multiplas classes existe ainda um segundo criterio
    % de consistencia baseado no numero de instancias correta e
    % incorretamente classificadas sem considerar seus pesos. Isto porque
    % regras geradas em estagios avancados fazem generalizacoes incorretas
    % baseadas nas poucas instancias remanescentes com altos pesos.
    m_plus = sum(mu_matches);
    m_minus = sum(mu_nomatches);
    f4 = 0 * (m_plus < m_minus) + ((m_plus - m_minus) / m_plus) * (m_plus >= m_minus);
    
    result = f1 * f2 * f3 * f4;
end