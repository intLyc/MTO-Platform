% function alpha1 = Em_bijiao12_jin(obj, min_Niche12_Obj, epsilon2)
function alpha1 = Em_bijiao12_tasks_all_best(obj, xinxing12_obj, epsilon2)

alpha1 = zeros(1, size(xinxing12_obj, 2));
for ii = 1:size(xinxing12_obj, 2)
    if xinxing12_obj(obj.Gen, ii).CV < epsilon2 && xinxing12_obj(obj.Gen - 1, ii).CV < epsilon2
        if xinxing12_obj(obj.Gen, ii).Obj < xinxing12_obj(obj.Gen - 1, ii).Obj
            alpha1(ii) = 1;
        end

    elseif xinxing12_obj(obj.Gen, ii).CV == xinxing12_obj(obj.Gen - 1, ii).CV
        if xinxing12_obj(obj.Gen, ii).Obj < xinxing12_obj(obj.Gen - 1, ii).Obj
            alpha1(ii) = 1;
        end

    elseif xinxing12_obj(obj.Gen, ii).CV < xinxing12_obj(obj.Gen - 1, ii).CV
        alpha1(ii) = 1;
    end
end

end
