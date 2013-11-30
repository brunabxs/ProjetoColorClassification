function rules = training(training_set)
    % inicializa o vetor de pesos
    for i = 1 : numel(training_set)
        training_set(i).w = 1;
    end
    
    % prepara opcoes do AG
    GENOME_LENGTH = 15;
    OPTIONS = gaoptimset('PopulationSize', 40, ...
    'PopulationType', 'doubleVector', ...
    'Generations', 1000, ...
    'CreationFcn', @(GENOME_LENGTH, ga_fitness_function, OPTIONS) ga_creation_function(GENOME_LENGTH, ga_fitness_function, OPTIONS, training_set), ...
    'SelectionFcn', @selectionroulette, ...
    'CrossoverFcn', @crossoversinglepoint, ...
    'MutationFcn', @mutationuniform, ...
    'CrossoverFraction', 0.8, ...
    'UseParallel', 'always', ...
    'Vectorized', 'off');
    
    rules = [];
    for i = 1 : 20
        % executa o AG e encontra a melhor regra
        best = ga(@(genome) ga_fitness_function(genome, training_set), GENOME_LENGTH, [], [], [], [], [], [], [], OPTIONS);
        
        % dado o cromossomo, encontra a regra correspondente
        rule = create_rule(best, training_set);
        
        % atualiza a probabilidade de cada instancia de treinamento
        [training_set, rule.error] = boosting(rule, training_set);
        
        % insere regra na base de regras
        rules = [rules rule];
    end
end

function [training_set, rule_error] = boosting(rule, training_set)
    % encontra quais as instancias de treinamento que nao foram classificadas 
    % como a regra
    training_set_class_rule_nomatches = find([training_set(:).class] ~= rule.class);
    
    % encontra os pesos das instancias de treinamento nao classificadas como a
    % regra
    w = [training_set(:).w]';
    w_nomatches = [training_set(training_set_class_rule_nomatches).w]';
    
    % encontra o valor da regra das instancias de treinamento nao classificadas 
    % como a regra    
    mu_nomatches = rule.mu(training_set(training_set_class_rule_nomatches));

    % calcula o erro
    rule_error = sum(w_nomatches .* mu_nomatches) / sum(w .* rule.mu(training_set));
    
    % calula o termo beta
    beta = (rule_error / (1 - rule_error)) .^ mu_nomatches;
    
    % atualiza as probabilidades
    prob = w_nomatches .* beta;
    for i = 1 : numel(training_set_class_rule_nomatches)
        training_set(i).w = prob(i);
    end
end