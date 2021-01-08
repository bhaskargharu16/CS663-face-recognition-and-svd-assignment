%% Training
clear; clc;
im_r=192;
im_c=168;
im_n=im_r*im_c;
num_person=38;
train_per_person=40;
N=num_person*train_per_person;
train_X=zeros(im_n,N);
test_X=[];
test_map=[];

D = '../data/CroppedYale';
S = dir(fullfile(D,'*'));
N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of D.
for ii = 1:numel(N)
    num=0;
    T = dir(fullfile(D,N{ii},'*')); % improve by specifying the file extension.
    C = {T(~[T.isdir]).name}; % files in subfolder.
    for jj = 1:numel(C)
        F = fullfile(D,N{ii},C{jj});
        img=imread(F);
        if num>=40
            test_X=[test_X img(:)];
            test_map=[test_map ii];
        else
            train_X(:,train_per_person*(ii-1)+jj)=img(:);
        end
        num=num+1;
    end
end

train_mean_X=mean(train_X,2);
train_bar_X=train_X-train_mean_X;
[U,S,~]=svd(train_bar_X,'econ');

%% Testing

test_bar_X=double(test_X)-train_mean_X;
y=[];
x=0;
Ks = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];
for k = Ks
    Uk=U(:,4:k+3);
    train_E=Uk'*train_bar_X;
    test_E=Uk'*test_bar_X;
    correct=0;
    s0=0;
    x=x+1;
    for i = 1:size(test_X,2)
            arr=sqrt(sum((train_E-test_E(:,i)).^2,1));
            [~,idx]=min(arr);
            s0=s0+1;
            if (1+floor((idx-1)/train_per_person))==test_map(i)
                correct=correct+1;
            end
    end
    y(x)=(100*correct)/s0;
end
%% Testing results 
figure;
plot(Ks,y);
title('K vs accuracy');