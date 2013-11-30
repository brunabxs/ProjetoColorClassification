function result = classify(rules, test_set)
    for i = 1 : numel(test_set);
        test_set(i) = apply_classifier(rules, test_set(i));
    end

    result = test_set(:);
end

function instance = apply_classifier(rules, instance)
    num_classes = max([rules(:).class]);
    classes = zeros(1, num_classes);
    
    for rule = rules
        beta = rule.error / (1 - rule.error);
        classes(rule.class) = classes(rule.class) + log10(1 / beta) .* rule.mu(instance);
    end
    
    [~, max_pos] = max(classes);
    instance.class = max_pos;
end