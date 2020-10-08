for order = 1:8
        errs = zeros(3,4);
        for ref = 0:2
                disp(sprintf("order %d refinement %d:", order, ref))
                err = vortex(order, ref);
                disp(err');
                errs(ref+1, :) = err';
        end
        raterho = log(errs(end, 1)/errs(1, 1))/log(4)
        raterhou = log(errs(end, 2)/errs(1, 2))/log(4)
end
