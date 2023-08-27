'''
Constants used for the rest of the scripts
'''


# data directories from root
DATA_RAW_DIR = 'data/raw/'
DATA_CLEAN_DIR = 'data/clean/'

ACCIDENT_MAIN_DIR = 'ACCIDENT/'

ACCIDENT_DATA_GENERAL_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'ACCIDENT.csv'
ACCIDENT_DATA_NODE_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'NODE.csv'
ACCIDENT_DATA_PERSON_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'PERSON.csv'
ACCIDENT_DATA_ATMOSPHERIC_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'ATMOSPHERIC_COND.csv'
ACCIDENT_DATA_ROAD_COND_DIR = DATA_RAW_DIR + ACCIDENT_MAIN_DIR + 'ROAD_SURFACE_COND.csv'

ROUGHLY_CLEANED_DATA_DIR = DATA_CLEAN_DIR + 'roughly_cleaned.csv'
FULLY_CLEANED_DATA_DIR = DATA_CLEAN_DIR + 'fully_cleaned.csv'

TRAINING_DATA_DIR = DATA_CLEAN_DIR + 'train.csv'
TESTING_DATA_DIR = DATA_CLEAN_DIR + 'test.csv'


EARLIEST_DATE = '2015/01/01'

TRAIN_SPLIT_MIN_DATE = '2015/01/01'
TEST_TRAIN_SPLIT_DATE = '2018/01/01'
TEST_SPLIT_MAX_DATE = '2020/01/01'