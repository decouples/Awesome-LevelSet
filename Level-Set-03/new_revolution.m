function phi= new_revolution(I,phi0,g,gx,gy,mu,nu,lambda,delta_t,epsilon,numIter);
%   new_revolution(I,phi0,g,gx,gy,mu,nu,lambda,delta_t,epsilon,numIter)
%   input: 
%       I: input image
%       phi0: level set function to be updated
%       g: edge detector g
%       gx,gy: gradient of edge detector g
%       mu: distRictTerm coefficient
%       nu: weight for area term, default value 0
%       lambda: lengthTerm coefficient
%       delta_t: time step
%       epsilon: parameter for computing smooth Heaviside and dirac function
%       numIter: number of iterations
%   output: 
%       phi: updated level set function



I = BoundMirrorExpand(I); % �����Ե����
phi = BoundMirrorExpand(phi0);
%����div(g*Nabla(phi))��Ҫ������
%div(uV)=Vxgrad(u) + u.*div(V)
[phix,phiy]=gradient(phi);
temp=sqrt(phix.^2 + phiy.^2 + 1e-10);%%ȱ��1e-10��ᵼ��������ʧ
phix=phix./temp;
phiy=phiy./temp;

for k = 1 : numIter
    phi = BoundMirrorEnsure(phi);
    delta_h = Delta(phi,epsilon);
    Curv = curvature(phi);
    
    % updating the phi function
    distRictTerm = mu * (4 * del2(phi) - Curv);
    lengthTrem = lambda * delta_h .*( phix.*gx + phiy.*gy + g.*Curv);
    areaTerm = nu * g .* delta_h;
    new_term = distRictTerm + lengthTrem + areaTerm;
    phi = phi + delta_t * new_term;
end
phi = BoundMirrorShrink(phi); % ȥ�����صı�Ե



