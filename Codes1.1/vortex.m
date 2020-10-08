function [norms] = vortex(n,reflevel)
    % Driver script for solving the 2D Euler equations
    Globals2D;
    N = n;

    % Order of polynomials used for approximation
    % N = 1;

    % Read in Mesh
    filename = 'Grid/Euler2D/vortexA04.neu';
    InitialSolution = @IsentropicVortexIC2D;
    ExactSolution   = @IsentropicVortexIC2D;
    BCSolution      = @IsentropicVortexBC2D;

    % read mesh from file
    [Nv, VX, VY, K, EToV, BCType] = MeshReaderGambitBC2D(filename);

    % set up nodes and basic operations
    StartUp2D;

    % turn cylinders into walls
    ids = find(BCType==Cyl);
    BCType(ids) = Wall;

    for i = 1:reflevel,
        % disp(K);
        refineflag = ones(K,1);
        Hrefine2D(refineflag);
        StartUp2D;
        %disp(K)
    end;

    BuildBCMaps2D;

    % compute initial condition
    Q = feval(InitialSolution, x, y, 0);

    % Solve Problem
    FinalTime = 1;
    [Q] = Euler2D(Q, FinalTime, BCSolution);
    QEX = feval(ExactSolution, x, y, FinalTime);
    rho = Q(:,:,1);     rhou = Q(:,:,2);     rhov = Q(:,:,3);     Ener = Q(:,:,4);
    rhoEX = QEX(:,:,1); rhouEX = QEX(:,:,2); rhovEX = QEX(:,:,3); EnerEX = QEX(:,:,4);
    norms = zeros(4,1);
    for i = 1:4,
        norms(i) = L2norm(Q(:,:,i)-QEX(:,:,i));
    end
end

function [nrm] = L2norm(v)
  Globals2D;

  MassMatrix = invV'*invV;
  MMv = MassMatrix*(J.*v);
  nrm = sqrt(v(:)'*MMv(:));
end
