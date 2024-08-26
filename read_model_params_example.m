clc
for model_no = 1:size(P2DZU.Kp,2)
    numerator = P2DZU.Kp(model_no)*[ P2DZU.Tz(model_no) 1];
    denominator = [P2DZU.Tw(model_no)^2 2* P2DZU.Tw(model_no)* P2DZU.Zeta(model_no) 1];



    temp_model = tf(numerator, denominator, ...
        'InputDelay', P2DZU.Td(model_no));
end