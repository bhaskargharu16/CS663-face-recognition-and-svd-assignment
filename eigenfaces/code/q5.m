%% Training
clear;
im_r=112;
im_c=92;
im_n=im_r*im_c;
num_person=32;
train_per_person=6;
N=num_person*train_per_person;
train_X=zeros(im_n,N);

for i = 1:num_person
    for j = 1:train_per_person
        path="../data/ORL/s"+i+"/"+j+".pgm";
        img=imread(path);
        train_X(:,6*(i-1)+j)=img(:);
    end
end

train_mean_X=mean(train_X,2);
train_bar_X=train_X-train_mean_X;

[U,S,~]=svd(train_bar_X);

%% reconstruction of image
train_bar_X = train_bar_X(:,1);
i = 1;
figure;
for k = [2,10,20,50,75,100,125,150,175]
    Uk = U(:,1:k);
    alphaik = Uk' * train_bar_X;
    reconstruction = train_mean_X;
    reconstruction = reconstruction + Uk*alphaik;
    reconstruction = reshape(reconstruction,[im_r,im_c]);
    subplot(3,3,i);
    imshow(mat2gray(reconstruction));
    title("k = " + k);
    i = i+1;
end

%% eigenfaces plotting

eigenfaces = U(:,1:25);
figure;
for i=1:5
    for j=1:5
        eigenvector = eigenfaces(:,5*(i-1)+j);
        amin = min(eigenvector);
        amax = max(eigenvector);
        eigenvector = reshape(eigenvector,[im_r,im_c]);
        subplot(5,5,5*(i-1)+j);
        imshow(mat2gray(eigenvector,[amin,amax]));
        title(5*(i-1)+j);
    end
end
