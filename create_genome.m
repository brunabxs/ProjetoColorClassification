function genome = create_genome(instance1, instance2)

    r1 = instance1.r;
    r2 = instance2.r;
    
    b = min(r1, r2);
    c = max(r1, r2);
    a = b - abs(r1 - r2) / 2;
    d = c + abs(r1 - r2) / 2;
    delta1 = b - a;
    delta2 = c - b;
    delta3 = d - c;
    
    r = [a, delta1, delta2, delta3];
    genome = r

    g1 = instance1.g;
    g2 = instance2.g;
    
    b = min(g1, g2);
    c = max(g1, g2);
    a = b - abs(g1 - g2) / 2;
    d = c + abs(g1 - g2) / 2;
    delta1 = b - a;
    delta2 = c - b;
    delta3 = d - c;
    
    g = [a, delta1, delta2, delta3];
    genome = [genome g]
    
    b1 = instance1.g;
    b2 = instance2.g;
    
    b = min(b1, b2);
    c = max(b1, b2);
    a = b - abs(b1 - b2) / 2;
    d = c + abs(b1 - b2) / 2;
    delta1 = b - a;
    delta2 = c - b;
    delta3 = d - c;
    
    b = [a, delta1, delta2, delta3];
    genome = [genome b]
    
    genome = [genome 1 1 1]
end