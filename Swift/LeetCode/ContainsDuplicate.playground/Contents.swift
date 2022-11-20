import UIKit

class MySolution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        let temp = Set(nums)
        return nums.count > temp.count
    }
}

let solution = MySolution()
solution.containsDuplicate([131, 951, 372, 358, 627, 764, 947, 514, 266, 292, 574, 281, 657, 434, 728, 903, 800, 656, 155, 952, 490, 529, 673, 207, 812, 779, 616, 261, 134, 105, 497, 491, 64, 790, 606, 769, 782, 63, 155, 656, 4, 342, 237, 502, 132, 164, 495, 514, 366, 538, 813, 77, 706, 699, 14, 937, 930, 391, 570, 193, 620, 267, 558, 384, 592, 250, 230, 810, 72, 130, 965, 148, 110, 806, 438, 994, 812, 528, 365, 300, 635, 945, 859, 263, 836, 904, 614, 956, 655, 433, 713, 545, 186, 155, 782, 225, 295, 916, 952, 576, 773, 570, 792, 824, 973, 806, 893, 800, 630, 950, 561, 571, 757, 814, 789, 758, 525, 564, 923, 743, 848, 705, 897, 891, 650, 796, 657, 525, 557, 807, 653, 836, 683, 869, 814, 851, 631, 666, 597, 845, 868, 617, 978, 521, 641, 948, 798, 749, 848, 718, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 840, 841, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 991, 992, 993, 994, 995, 996, 997, 998, 999, 1000]
)


import XCTest

class Tests: XCTestCase {
    
    let solution = MySolution()
    
    func testSolution() {
        XCTContext.runActivity(named: "重複なし") { _ in
            let value = solution.containsDuplicate([1,2,3,4])
            XCTAssertEqual(value, false)
        }
        
        XCTContext.runActivity(named: "重複が1つ") { _ in
            let value = solution.containsDuplicate([1,2,3,1])
            XCTAssertEqual(value, true)
        }
        
        XCTContext.runActivity(named: "重複が複数") { _ in
            let value = solution.containsDuplicate([1,1,1,3,3,4,3,2,4,2])
            XCTAssertEqual(value, true)
        }
    }
}

class BestSolution {
    func containsDuplicate(_ nums: [Int]) -> Bool {

       var mySet: Set<Int> = []

       for value in nums {
           if mySet.contains(value) {
               return true
           }
           mySet.insert(value)
       }

       return false
    }
}
