% function alpha2 = Em_bijiao21_jin(obj, min_Niche21_Obj, epsilon1)
function alpha2 = Em_bijiao21_tasks_all_best(obj, xinxing21_obj, epsilon1)

alpha2 = zeros(1, size(xinxing21_obj, 2));
for ii = 1:size(xinxing21_obj, 2)
    if xinxing21_obj(obj.Gen, ii).CV < epsilon1 && xinxing21_obj(obj.Gen - 1, ii).CV < epsilon1
        if xinxing21_obj(obj.Gen, ii).Obj < xinxing21_obj(obj.Gen - 1, ii).Obj
            alpha2(ii) = 1;
        end

    elseif xinxing21_obj(obj.Gen, ii).CV == xinxing21_obj(obj.Gen - 1, ii).CV
        if xinxing21_obj(obj.Gen, ii).Obj < xinxing21_obj(obj.Gen - 1, ii).Obj
            alpha2(ii) = 1;
        end

    elseif xinxing21_obj(obj.Gen, ii).CV < xinxing21_obj(obj.Gen - 1, ii).CV
        alpha2(ii) = 1;
    end
end

end
