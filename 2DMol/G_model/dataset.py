from __future__ import print_function
import torch.utils.data as data
import os
import os.path
import torch
import numpy as np
import argparse
import sys
from tqdm import tqdm
import json
from plyfile import PlyData, PlyElement
 
 
class ModelNetDataset(data.Dataset):
    def __init__(self,
                 root,
                 npoints=2500,
                 split='train',
                 data_augmentation=True):
        self.npoints = npoints
        self.root = root
        self.split = split
        self.data_augmentation = data_augmentation
        self.fns = []
        with open(os.path.join(root, 'owndata_{}.txt'.format(self.split)), 'r') as f:
            for line in f:
                self.fns.append(line.strip())    # line.strip() is using to remove end terminator
 
        self.cat = {}   #calss
        with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '/data/home/zhaoyj/01ML/pointnet.pytorch.3D-v2/misc/owndata_id.txt'), 'r') as f:
            for line in f:
                ls = line.strip().split()
                self.cat[ls[0]] = int(ls[1])
        print(self.cat)
        self.classes = list(self.cat.keys())
 
    def __getitem__(self, index):
        file_index = self.fns[index]        # eg: index:4 -> interphase_1018
        cls_name = file_index.rsplit(sep='_',maxsplit=1)[0]   # eg: crumple
        cls = self.cat[cls_name]    # eg: out:[0]; interphase belongs to [0], quasiflat belongs to [3]
        file_name = '{}/{}.txt'.format(cls_name,file_index)  # eg: fold/fold_2170.txt
        pts = np.loadtxt(os.path.join(self.root,file_name),delimiter=' ',dtype=float)[:,1:4]
        # Random downsampling to improve model robustness
        choice = np.random.choice(len(pts), self.npoints, replace=True)
        #numpy.random.choice(a, size=None, replace=True, p=None)

 
        point_set = pts[choice, :]
 
        point_set = point_set - np.expand_dims(np.mean(point_set, axis=0), 0)  # center
        dist = np.max(np.sqrt(np.sum(point_set ** 2, axis=1)), 0)
        point_set = point_set / dist  # scale
 
        if self.data_augmentation:
            theta = np.random.uniform(0, np.pi * 2)
            rotation_matrix = np.array([[np.cos(theta), -np.sin(theta)], [np.sin(theta), np.cos(theta)]])
            point_set[:, [0, 2]] = point_set[:, [0, 2]].dot(rotation_matrix)  # random rotation
            point_set += np.random.normal(0, 0.02, size=point_set.shape)  # random jitter
 
        point_set = torch.from_numpy(point_set.astype(np.float32))
        cls = torch.from_numpy(np.array([cls]).astype(np.int64))
        return point_set, cls
 
    def __len__(self):
        return len(self.fns)
 
 
if __name__ == '__main__':
    datapath = "/data/home/zhaoyj/01ML/pointnet.pytorch.3D-v2/owndata/"
    dataset = ModelNetDataset(
        root=datapath,
        npoints=2500,
        split='train')
    test_dataset = ModelNetDataset(
        root=datapath,
        npoints=2500,
        split='test',
        data_augmentation=False)
 
    dataloder = torch.utils.data.DataLoader(
        dataset,
        batch_size=32,
        shuffle=True,
        num_workers=4
    )
    testdataloder = torch.utils.data.DataLoader(
        test_dataset,
        batch_size=32,
        shuffle=True,
        num_workers=4
    )
    for epoch in range(10):
        for step,data in enumerate(dataloder,0):    
            points , target = data
            target = target[:,0]
            print('Epoch: ', epoch, '| Step: ', step, '| points: ',
                  points.numpy(), '| target: ', target.numpy())
