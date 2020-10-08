for order = 1:8
        for ref = 0:2
                disp(sprintf("order %d refinement %d:", order, ref))
                disp(vortex(order, ref)');
        end
end
