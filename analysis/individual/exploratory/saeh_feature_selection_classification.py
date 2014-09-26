

from collections import defaultdict
import json
import pandas as pd

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import csv
from math import sqrt

from matplotlib import rcParams
import matplotlib.cm as cm
import matplotlib as mpl

#colorbrewer2 Dark2 qualitative color table
dark2_colors = [(0.10588235294117647, 0.6196078431372549, 0.4666666666666667),
                (0.8509803921568627, 0.37254901960784315, 0.00784313725490196),
                (0.4588235294117647, 0.4392156862745098, 0.7019607843137254),
                (0.9058823529411765, 0.1607843137254902, 0.5411764705882353),
                (0.4, 0.6509803921568628, 0.11764705882352941),
                (0.9019607843137255, 0.6705882352941176, 0.00784313725490196),
                (0.6509803921568628, 0.4627450980392157, 0.11372549019607843)]

rcParams['figure.figsize'] = (10, 6)
rcParams['figure.dpi'] = 150
rcParams['axes.color_cycle'] = dark2_colors
rcParams['lines.linewidth'] = 2
rcParams['axes.facecolor'] = 'white'
rcParams['font.size'] = 14
rcParams['patch.edgecolor'] = 'white'
rcParams['patch.facecolor'] = dark2_colors[0]
rcParams['font.family'] = 'StixGeneral'

import pickle
import random
from sklearn.preprocessing import Imputer
from sklearn.cross_validation import train_test_split

import subprocess

#clear memory from time to time
#take out this line if you are only
#running one file
bashCommand = 'sudo purge'

#set up classifier
from sklearn.ensemble import GradientBoostingClassifier

#function to select nrows randomly from a dataframe
def random_rows_dataframe(df, nrows):
    return df.ix[random.sample(df.index, nrows)]


#get dataframe for dead mothers
df_dead = pickle.load( open( "extracted_data/df_dead.pickle", "rb" ) )

filenames = []


#read in complete data
#df_complete = pd.read_csv("saeh_splits/F1", header = 0)

def do_classification(filename, df_dead, runs):

    #read dataframe
    df_complete = pd.read_csv(filename, header = 0)
    
    prediction_accuracy = []
    complete_feature_importance_dictionary = {}
    
    for i in range(runs):
        #select and append two dataframes
        total_to_classify = df_dead.append(random_rows_dataframe(df_complete[df_complete['dead'] == 0], 325), ignore_index=True)

        y = total_to_classify['dead']
        total_to_classify =  total_to_classify.drop('dead', 1)
        get_columns_list = list(total_to_classify.columns.values)

        #impute missing features so sklearn doesnt scream
        imp = Imputer(missing_values='NaN', strategy='mean', axis=0)

        new_X = imp.fit_transform(total_to_classify.values, y)

        X_train, X_test, y_train, y_test = train_test_split(new_X, y, test_size=0.33, random_state=457)

        clf = GradientBoostingClassifier(n_estimators = 300, learning_rate=0.1, max_depth=4, max_features=0.1, min_samples_leaf=5, verbose = 0)
        clf.fit(X_train, y_train)
        pred = clf.predict(X_test)
        acc = clf.score(X_test, y_test)
        
        #you don't need to tune hyperparameters,
        #already did this.
        '''
        #tune hyperparameters
        from sklearn.grid_search import GridSearchCV
        param_grid = { 'learning_rate': [0.1, 0.05, 0.02, 0.01],
                    'max_depth':[4,6],
                    'min_samples_leaf' : [3,5,9,17],
            'max_features' : [1.0, 0.3, 0.1]
                }
        clf = GradientBoostingClassifier(n_estimators = 200, verbose = 1)
        gs_cv = GridSearchCV(clf, param_grid).fit(X_train, y_train)
        gs_cv.best_params_
        '''
    
        feature_importance = clf.feature_importances_

        #process important features
        feature_importance = 100.0 * (feature_importance / feature_importance.max())

        #sort in descending order
        sorted_idx = (-np.array(feature_importance)).argsort()

        #get top 50 features
        top_50_features = sorted_idx[0:50]
    
        prediction_accuracy.append(acc)
        
        print filename + " run -->> " + str(i)
        
        for fec in top_50_features:
            if get_columns_list[fec] in complete_feature_importance_dictionary:
                complete_feature_importance_dictionary[get_columns_list[fec]].append(feature_importance[fec])
            else:
                complete_feature_importance_dictionary[get_columns_list[fec]] = []
                complete_feature_importance_dictionary[get_columns_list[fec]].append(feature_importance[fec])

        #take this out
        #I was running into memory issues with running the file with 1mill rows, so I included this
        #you don't need it. 
        process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
        output = process.communicate()[0]
            
    return prediction_accuracy, complete_feature_importance_dictionary

#the total data might be too big for your ram
filenames = ['extracted_data/saeh_maternal_2011_subsection']

list_accuracies = []
list_feature_importances = []

for filename in filenames:
    accuracy_total, feature_imp_dict = do_classification(filename, df_dead, 100)
    list_accuracies.append(accuracy_total)
    list_feature_importances.append(feature_imp_dict)
    
    print filename + " mean accuracy of prediction --->> " + str(np.array(accuracy_total).mean())
    
    #write results to file. 
    pickle.dump(list_accuracies, open(filename + "_total_accuracy_for_classification.pickle", "wb"))
    pickle.dump(list_feature_importances, open(filename + "_features_dictionary.pickle", "wb"))

    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
    output = process.communicate()[0]

