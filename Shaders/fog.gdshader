shader_type canvas_item;

uniform float densidad : hint_range(0.0, 1.0) = 0.25;
uniform float velocidad : hint_range(0.0, 0.5) = 0.03;
uniform float escala : hint_range(1.0, 10.0) = 3.5;
uniform vec4 color_niebla : source_color = vec4(0.6, 0.65, 0.8, 1.0);

// Funciones de ruido
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Varias capas de ruido superpuestas = más orgánico
float fbm(vec2 p) {
    float valor = 0.0;
    float amplitud = 0.5;
    
    for (int i = 0; i < 4; i++) {
        valor += amplitud * noise(p);
        p *= 2.1;            // cada capa más detallada
        amplitud *= 0.5;     // cada capa menos intensa
    }
    return valor;
}

void fragment() {
    // Mueve el fog en diagonal muy lentamente
    vec2 uv = UV * escala + vec2(TIME * velocidad, TIME * velocidad * 0.6);
    
    float niebla = fbm(uv);
    
    // Suaviza los bordes del fog (no corte abrupto)
    niebla = smoothstep(0.3, 0.75, niebla);
    
    // COLOR ya tiene la luz aplicada por Godot
    // Solo modificamos el alpha para controlar densidad
    COLOR = vec4(color_niebla.rgb, niebla * densidad);
}
