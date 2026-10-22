class LearningTopic {
  const LearningTopic(this.name, this.words);
  final String name;
  final int words;
}

const topics = [
  LearningTopic('Family', 264),
  LearningTopic('Employment', 214),
  LearningTopic('Finance', 164),
  LearningTopic('Business', 324),
  LearningTopic('Emotion', 224),
  LearningTopic('Marketing', 412),
  LearningTopic('Travel', 186),
  LearningTopic('Education', 248),
];

class VocabularyCard {
  const VocabularyCard(
    this.word,
    this.topic,
    this.phonetic,
    this.options,
    this.answer,
    this.illustration,
  );
  final String word, topic, phonetic, illustration;
  final List<String> options;
  final int answer;
}

const vocabulary = [
  VocabularyCard(
    'parent',
    'Family',
    '/ˈper.ənt/',
    ['anh em', 'bạn bè', 'cha mẹ', 'hàng xóm'],
    2,
    'card_family',
  ),
  VocabularyCard(
    'analyse',
    'Finance',
    '/ˈæn.əl.aɪz/',
    ['phân tích', 'hợp đồng', 'gia đình', 'thị trường'],
    0,
    'card_finance',
  ),
  VocabularyCard(
    'initiator',
    'Marketing',
    '/ɪˈnɪʃ.i.eɪ.tər/',
    ['người mua', 'người khởi xướng', 'đồng nghiệp', 'đối tác'],
    1,
    'card_marketing',
  ),
  VocabularyCard(
    'contract',
    'Finance',
    '/ˈkɒn.trækt/',
    ['công việc', 'tiền lương', 'hợp đồng', 'ngân hàng'],
    2,
    'card_finance',
  ),
  VocabularyCard(
    'sibling',
    'Family',
    '/ˈsɪb.lɪŋ/',
    ['hàng xóm', 'cha mẹ', 'bạn bè', 'anh chị em'],
    3,
    'card_family',
  ),
  VocabularyCard(
    'campaign',
    'Marketing',
    '/kæmˈpeɪn/',
    ['chiến dịch', 'nghề nghiệp', 'quảng cáo', 'mục tiêu'],
    0,
    'card_marketing',
  ),
];

class Sentence {
  const Sentence(this.english, this.translation, this.image, this.duration);
  final String english, translation, image, duration;
}

const sentences = [
  Sentence('I scraped my knee.', 'Tôi bị xước đầu gối.', 'knee', '0:24'),
  Sentence(
    'It’s just a scratch.',
    'Chỉ xước nhẹ thôi ý mà.',
    'scratch',
    '0:17',
  ),
  Sentence(
    'I have a scar on my foot.',
    'Tôi có một vết sẹo trên bàn chân.',
    'scratch',
    '0:14',
  ),
  Sentence(
    'I found a scab on my head.',
    'Tôi thấy một cái vẩy trên đầu tôi.',
    'travel',
    '0:24',
  ),
  Sentence('My arm is broken.', 'Tôi bị gãy tay.', 'knee', '0:24'),
];

const conversation = [
  ('Hey there', 'Xin chào', 'Ellen'),
  (
    'Hey, where are you going today?',
    'Chào cô, hôm nay cô sẽ đi đâu?',
    'Taxi Driver',
  ),
  ('25 Gerhold Valley, please.', 'Cho tôi tới 25 Gerhold Valley.', 'Ellen'),
  ('No problem.', 'Không thành vấn đề.', 'Taxi Driver'),
  ('So here we are.', 'Chúng ta tới rồi đây.', 'Taxi Driver'),
  ('Oh, great.', 'Ồ, tuyệt.', 'Ellen'),
];
const lessonTitles = [
  'Go buy shoes',
  'Asking for Directions',
  'When taking a taxi',
  'Order in a restaurant',
  'At the airport',
  'A day at work',
  'Making new friends',
  'Going shopping',
  'At the hotel',
  'Let’s talk',
];
const lessonSubtitles = [
  'All Faith Needs Feet',
  'Burning Desire Golden Key',
  'How To Set Intentions',
  'Discover Your Path',
];

/// Each Pixso frame has an executable route, also used by the screenshot runner.
const screenCatalog = <({String file, String path, String node})>[
  (file: '00_1_splash', path: '/splash', node: '0:5158'),
  (file: '00_2_onboarding_sentences', path: '/onboarding/0', node: '0:5160'),
  (file: '00_3_onboarding_speaking', path: '/onboarding/1', node: '0:5413'),
  (file: '00_4_onboarding_vocabulary', path: '/onboarding/2', node: '0:5681'),
  (file: '00_5_sign_up', path: '/signup', node: '0:5949'),
  (file: '00_6_sign_in', path: '/signin', node: '0:5995'),
  (file: '01_home', path: '/home', node: '0:5095'),
  (file: '02_1_post', path: '/post', node: '0:4968'),
  (file: '02_2_post_dictionary', path: '/post/dictionary', node: '0:4901'),
  (file: '02_3_post_repeat', path: '/post/repeat', node: '0:4837'),
  (file: '02_4_post_practice', path: '/post/practice', node: '0:4711'),
  (file: '03_1_test_sentence', path: '/quiz/0', node: '0:4676'),
  (file: '03_2_test_meaning', path: '/quiz/1', node: '0:4646'),
  (file: '03_3_test_listening', path: '/quiz/2', node: '0:4606'),
  (file: '03_4_test_score', path: '/result/test/60', node: '0:4589'),
  (file: '03_5_test_perfect', path: '/result/test/100', node: '0:4433'),
  (file: '05_1_search', path: '/search', node: '0:4389'),
  (file: '05_2_search_movie', path: '/category/Movie', node: '0:4326'),
  (file: '05_3_channel', path: '/channel', node: '0:4235'),
  (file: '06_1_speaking', path: '/speak', node: '0:720'),
  (file: '06_2_course', path: '/course', node: '0:677'),
  (file: '06_3_conversation', path: '/conversation', node: '0:611'),
  (file: '06_4_listen', path: '/listen', node: '0:566'),
  (file: '06_5_speaking_practice', path: '/speaking', node: '0:529'),
  (file: '06_6_speaking_score', path: '/result/speaking/75', node: '0:512'),
  (file: '06_7_speaking_perfect', path: '/result/speaking/100', node: '0:2'),
  (file: '07_1_topics', path: '/topics', node: '0:777'),
  (file: '07_1_word_board', path: '/words', node: '0:1021'),
  (file: '07_2_word_card', path: '/words/card', node: '0:3556'),
  (file: '07_3_correct_words', path: '/words/correct', node: '0:1643'),
  (file: '07_4_wrong_words', path: '/words/wrong', node: '0:2501'),
  (file: '07_5_level_up', path: '/level-up', node: '0:158'),
  (file: '08_1_profile', path: '/profile', node: '0:837'),
  (file: '08_2_native_language', path: '/language', node: '0:990'),
];
