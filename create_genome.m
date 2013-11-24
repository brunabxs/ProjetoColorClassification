function genome = create_genome(instance1, instance2)
    part_r = create_genome_part(instance1.r, instance2.r);
    part_g = create_genome_part(instance1.g, instance2.g);
    part_b = create_genome_part(instance1.b, instance2.b);
    s = [1 1 1];

    genome = [part_r part_g part_b s];
end

function part = create_genome_part(attribute1, attribute2)
    b = min(attribute1, attribute2);
    c = max(attribute1, attribute2);
    a = b - abs(attribute1 - attribute2) / 2;
    d = c + abs(attribute1 - attribute2) / 2;
    delta1 = b - a;
    delta2 = c - b;
    delta3 = d - c;
    
    part = [a, delta1, delta2, delta3];
end