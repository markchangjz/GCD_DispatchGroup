// http://www.appcoda.com.tw/grand-central-dispatch/
// http://stackoverflow.com/questions/32642782/waiting-for-multiple-asynchronous-download-tasks
// http://www.jianshu.com/p/228403206664

/*
1. Use dispatch_group_create() to create a group.
2. Call dispatch_group_enter(group) before starting each download task.
3. Call dispatch_group_leave(group) inside the task's completion handler.
4. Then call dispatch_group_notify(group, queue, ^{ ... }) to enqueue a block that will be executed when all the tasks are completed.
*/

import Foundation

func calculateDiff(_ num1: Int, _ num2: Int) -> Int {
	return abs(num1 - num2)
}

let list = [3, 2, 4, 5, 1, 7]
var diff = [Int]()

//let backgroundQueue = DispatchQueue.global(qos: .default)
//let backgroundQueue = DispatchQueue.global()
let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .default, attributes: .concurrent)
let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess")
let calculateDiffGroup = DispatchGroup()

for (index, _) in list.enumerated() {
	calculateDiffGroup.enter()
	backgroundQueue.async(group: calculateDiffGroup, execute: DispatchWorkItem {
		accessQueue.async {
			diff.append(calculateDiff(5, list[index]))
		}
		calculateDiffGroup.leave()
	})
}

calculateDiffGroup.notify(queue: DispatchQueue.main) {
	print(diff)
	print(diff.max() ?? -1)
}

RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))

/*
 題目：回傳與目標值，最大的 diff 值
 */
class Solution {
    func maxDiff(_ target: Int, _ list: [Int]) -> Int {
        var max = -1
        for e in list {
            let diff = abs(target - e)
            if diff > max  {
                max = diff
            }
        }
        return max
    }
}

assert(Solution().maxDiff(5, [3, 2, 4, 5, 1, 7]) == 4)
