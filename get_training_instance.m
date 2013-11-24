%Dado um conjunto de treinamento, escolher de forma "aleatoria" um dos
%elementos. A probabilidade de escolha de uma instancia e dada pelo
%atributo w.
function training_instance = get_training_instance(training_set)
    likelihood = cumsum([training_set(:).w]);
    likelihood = likelihood / max(likelihood);
    
    x = rand;
    for i = 1 : numel(likelihood)
        if likelihood(i) > x
            training_instance = i;
            break;
        end
    end
end