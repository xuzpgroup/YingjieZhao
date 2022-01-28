import os, shutil

base_dir = r"/data/home/zhaoyj/01ML/2Ddatasets-v2"

os.mkdir(base_dir)
train_dir = os.path.join(base_dir, 'train')
os.mkdir(train_dir)
validation_dir = os.path.join(base_dir, 'validation')
os.mkdir(validation_dir)
test_dir = os.path.join(base_dir,'test')
os.mkdir(test_dir)


train_crumple_dir = os.path.join(train_dir,'crumple')
os.mkdir(train_crumple_dir)
train_fold_dir = os.path.join(train_dir,'fold')
os.mkdir(train_fold_dir)
train_interphase_dir = os.path.join(train_dir,'interphase')
os.mkdir(train_interphase_dir)
train_quasiflat_dir = os.path.join(train_dir,'quasiflat')
os.mkdir(train_quasiflat_dir)



validation_crumple_dir = os.path.join(validation_dir,'crumple')
os.mkdir(validation_crumple_dir)
validation_fold_dir = os.path.join(validation_dir,'fold')
os.mkdir(validation_fold_dir)
validation_interphase_dir = os.path.join(validation_dir,'interphase')
os.mkdir(validation_interphase_dir)
validation_quasiflat_dir = os.path.join(validation_dir,'quasiflat')
os.mkdir(validation_quasiflat_dir)



test_crumple_dir = os.path.join(test_dir,'crumple')
os.mkdir(test_crumple_dir)
test_fold_dir = os.path.join(test_dir,'fold')
os.mkdir(test_fold_dir)
test_interphase_dir = os.path.join(test_dir,'interphase')
os.mkdir(test_interphase_dir)
test_quasiflat_dir = os.path.join(test_dir,'quasiflat')
os.mkdir(test_quasiflat_dir)

import random




crumple_dir = r"/data/home/zhaoyj/01ML/2Ddatasets-pre-v2/crumple"
filepaths =os.listdir(crumple_dir)
random.shuffle(filepaths)
num = 1
for i in range(len(filepaths)):
    filename = filepaths[i]
    if(num<=427):
        src = os.path.join(crumple_dir,filename)
        dst = os.path.join(train_crumple_dir,filename)
        shutil.copyfile(src, dst)
    elif(num>519):
        src = os.path.join(crumple_dir,filename)
        dst = os.path.join(test_crumple_dir,filename)
        shutil.copyfile(src, dst)
    else:
        src = os.path.join(crumple_dir,filename)
        dst = os.path.join(validation_crumple_dir,filename)
        shutil.copyfile(src, dst)

    num += 1

fold_dir = r"/data/home/zhaoyj/01ML/2Ddatasets-pre-v2/fold"
filepaths =os.listdir(fold_dir)
random.shuffle(filepaths)
num = 1
for i in range(len(filepaths)):
    filename = filepaths[i]
    if(num<=631):
        src = os.path.join(fold_dir,filename)
        dst = os.path.join(train_fold_dir,filename)
        shutil.copyfile(src, dst)
    elif(num>766):
        src = os.path.join(fold_dir,filename)
        dst = os.path.join(test_fold_dir,filename)
        shutil.copyfile(src, dst)
    else:
        src = os.path.join(fold_dir,filename)
        dst = os.path.join(validation_fold_dir,filename)
        shutil.copyfile(src, dst)

    num += 1

interphase_dir = r"/data/home/zhaoyj/01ML/2Ddatasets-pre-v2/interphase"
filepaths =os.listdir(interphase_dir)
random.shuffle(filepaths)
num = 1
for i in range(len(filepaths)):
    filename = filepaths[i]
    if(num<=573):
        src = os.path.join(interphase_dir,filename)
        dst = os.path.join(train_interphase_dir,filename)
        shutil.copyfile(src, dst)
    elif(num>798):
        src = os.path.join(interphase_dir,filename)
        dst = os.path.join(test_interphase_dir,filename)
        shutil.copyfile(src, dst)
    else:
        src = os.path.join(interphase_dir,filename)
        dst = os.path.join(validation_interphase_dir,filename)
        shutil.copyfile(src, dst)

    num += 1

quasiflat_dir = r"/data/home/zhaoyj/01ML/2Ddatasets-pre-v2/quasiflat"
filepaths =os.listdir(quasiflat_dir)
random.shuffle(filepaths)
num = 1
for i in range(len(filepaths)):
    filename = filepaths[i]
    if(num<=109):
        src = os.path.join(quasiflat_dir,filename)
        dst = os.path.join(train_quasiflat_dir,filename)
        shutil.copyfile(src, dst)
    elif(num>132):
        src = os.path.join(quasiflat_dir,filename)
        dst = os.path.join(test_quasiflat_dir,filename)
        shutil.copyfile(src, dst)
    else:
        src = os.path.join(quasiflat_dir,filename)
        dst = os.path.join(validation_quasiflat_dir,filename)
        shutil.copyfile(src, dst)

    num += 1

from tensorflow.keras.applications import VGG16

conv_base = VGG16(weights = 'imagenet',
                 include_top = False,
                 input_shape = (450,450,3))

from tensorflow.keras import models
from tensorflow.keras import layers

model = models.Sequential()
model.add(conv_base)
model.add(layers.Flatten())
model.add(layers.Dense(256, activation = 'relu'))
model.add(layers.Dense(4,activation = 'softmax'))
model.summary()

from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras import optimizers

train_datagen = ImageDataGenerator(
                rescale = 1./255,
      rotation_range = 40,
      width_shift_range = 0.2,
      height_shift_range = 0.2,
      shear_range = 0.2,
      zoom_range = 0.2,
      horizontal_flip = True,
      fill_mode = 'nearest')

validation_datagen = ImageDataGenerator(rescale = 1./255)

train_generator = train_datagen.flow_from_directory(
         '/data/home/zhaoyj/01ML/2Ddatasets-v2/train',
         target_size = (450,450),
         batch_size = 10,
         class_mode = 'categorical')

validation_generator = validation_datagen.flow_from_directory(
          '/data/home/zhaoyj/01ML/2Ddatasets-v2/validation',
         target_size = (450,450),
         batch_size = 5,
         class_mode = 'categorical')

model.compile(loss = 'categorical_crossentropy',
             optimizer = optimizers.RMSprop(lr = 2e-5),
             metrics=['acc'])

history = model.fit(
    train_generator,
    steps_per_epoch = 173,
    epochs = 25,
    validation_data = validation_generator,
    validation_freq= 2)

model.save('G+P-weight.h5')