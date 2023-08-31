'''
Constants used for the rest of the scripts
'''


#  ██████  ██ ██████      ██████  ███████ ███████ ██ ███    ██ ██ ████████ ██  ██████  ███    ██ ███████ 
#  ██   ██ ██ ██   ██     ██   ██ ██      ██      ██ ████   ██ ██    ██    ██ ██    ██ ████   ██ ██      
#  ██   ██ ██ ██████      ██   ██ █████   █████   ██ ██ ██  ██ ██    ██    ██ ██    ██ ██ ██  ██ ███████ 
#  ██   ██ ██ ██   ██     ██   ██ ██      ██      ██ ██  ██ ██ ██    ██    ██ ██    ██ ██  ██ ██      ██ 
#  ██████  ██ ██   ██     ██████  ███████ ██      ██ ██   ████ ██    ██    ██  ██████  ██   ████ ███████ 
#  
#  █▀▀ █▀█ █▀█ █▀▄▀█   █▀█ █▀█ █▀█ ▀█▀ 
#  █▀  █▀▄ █▄█ █ ▀ █   █▀▄ █▄█ █▄█  █  
#  
DATA_RAW_DIR = 'data/raw/'
DATA_CLEAN_DIR = 'data/clean/'


#  █▀█ ▄▀█ █ █ █   █▀▄ ▄▀█ ▀█▀ ▄▀█ 
#  █▀▄ █▀█ ▀▄▀▄▀   █▄▀ █▀█  █  █▀█ 
#  
ACCIDENT_MAIN_DIR = 'ACCIDENT/'
ACCIDENT_DATA_GENERAL_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'ACCIDENT.csv'
ACCIDENT_DATA_NODE_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'NODE.csv'
ACCIDENT_DATA_PERSON_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'PERSON.csv'
ACCIDENT_DATA_ATMOSPHERIC_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'ATMOSPHERIC_COND.csv'
ACCIDENT_DATA_ROAD_COND_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'ROAD_SURFACE_COND.csv'


#  █▀█ █▀█ █▀█ █▀▀ █▀▀ █▀ █▀ █ █▄ █ █▀▀   █▀▄ ▄▀█ ▀█▀ ▄▀█ 
#  █▀▀ █▀▄ █▄█ █▄▄ ██▄ ▄█ ▄█ █ █ ▀█ █▄█   █▄▀ █▀█  █  █▀█ 
#  
ROUGHLY_CLEANED_PRE_MERGE_DATA_DIR = DATA_CLEAN_DIR + 'roughly_cleaned_pre_merge.csv'
ROUGHLY_CLEANED_MERGE_1_DATA_DIR = DATA_CLEAN_DIR + 'roughly_cleaned_merge_1.csv'
ROUGHLY_CLEANED_MERGE_2_DATA_DIR = DATA_CLEAN_DIR + 'roughly_cleaned_merge_2.csv'
ROUGHLY_CLEANED_MERGE_3_DATA_DIR = DATA_CLEAN_DIR + 'roughly_cleaned_merge_3.csv'
ROUGHLY_CLEANED_DATA_DIR = DATA_CLEAN_DIR + 'roughly_cleaned.csv'
FULLY_CLEANED_DATA_DIR = DATA_CLEAN_DIR + 'fully_cleaned.csv'

#  ▀█▀ █▀▀ █▀ ▀█▀   ▄▀█ █▄ █ █▀▄   ▀█▀ █▀█ ▄▀█ █ █▄ █   █▀▄ ▄▀█ ▀█▀ ▄▀█ 
#   █  ██▄ ▄█  █    █▀█ █ ▀█ █▄▀    █  █▀▄ █▀█ █ █ ▀█   █▄▀ █▀█  █  █▀█ 
#  
TRAINING_DATA_DIR = DATA_CLEAN_DIR + 'train.csv'
TESTING_DATA_DIR = DATA_CLEAN_DIR + 'test.csv'
REGION_TRAINING_DATA_DIR = DATA_CLEAN_DIR + 'train_region.csv'
REGION_TESTING_DATA_DIR = DATA_CLEAN_DIR + 'test_region.csv'
PREPIVOT_TRAIN_TEST_DATA_DIR = DATA_CLEAN_DIR + 'pre_pivot_train_test.csv'


#  █▀▀ █▀█ ▄▀█ █▀█ █ █ █▀ 
#  █▄█ █▀▄ █▀█ █▀▀ █▀█ ▄█ 
#  
DATA_GRAPHS_DIR = 'data/images/'
DATA_INITIAL_ANALYSIS_DIR = DATA_GRAPHS_DIR + 'initial_analysis/'
DATA_FURTHER_ANALYSIS_DIR = DATA_GRAPHS_DIR + 'further_analysis/'
FINAL_MODEL_ANALYSIS_DIR = DATA_GRAPHS_DIR + 'final_model/'



#   ██████  ████████ ██   ██ ███████ ██████  
#  ██    ██    ██    ██   ██ ██      ██   ██ 
#  ██    ██    ██    ███████ █████   ██████  
#  ██    ██    ██    ██   ██ ██      ██   ██ 
#   ██████     ██    ██   ██ ███████ ██   ██ 
#  
#  █▀▄ ▄▀█ ▀█▀ █▀▀ █▀ 
#  █▄▀ █▀█  █  ██▄ ▄█ 
#  
EARLIEST_DATE = '2015/01/01'
TRAIN_SPLIT_MIN_DATE = '2015/01/01'
TEST_TRAIN_SPLIT_DATE = '2019/01/01'
TEST_SPLIT_MAX_DATE = '2020/01/01'


TRAINING_DATA_DIR = DATA_CLEAN_DIR + 'train.csv'
TESTING_DATA_DIR = DATA_CLEAN_DIR + 'test.csv'

#  █▀▀ █▀█ █   █▀█ █ █ █▀█   █▀ █▀▀ █ █ █▀▀ █▀▄▀█ █▀▀ 
#  █▄▄ █▄█ █▄▄ █▄█ █▄█ █▀▄   ▄█ █▄▄ █▀█ ██▄ █ ▀ █ ██▄ 
#  
POWERPOINT_RED = '#E03535'
POWERPOINT_GREY = '#eeeeee'
POWERPOINT_BLUE = '#00B0F0'
POWERPOINT_COLOUR_SCALE = [(0,POWERPOINT_BLUE ), (0.5,POWERPOINT_GREY ), (1, POWERPOINT_RED)]
