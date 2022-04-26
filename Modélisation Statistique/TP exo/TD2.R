library("mvtnorm")
rho=0.1
x=seq(-3,3,0.1)
y=seq(-3,3,0.1)
xy=expand.grid(x,y)
z=dmvnorm(xy,mean=c(0,0), sigma=matrix(c(1,rho,rho,1),ncol=2,byrow=TRUE))
zm=matrix(z,ncol=length(x),nrow=length(y),byrow=TRUE)
contour(x,y,z=t(zm))

