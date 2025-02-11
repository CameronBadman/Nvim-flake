from collections import OrderedDict

class NumberContainers:
    def __init__(self):
        self._numbersToContainer: dict[int, int] = {}
        
    def change(self, index: int, number: int) -> None:
        self._numbersToContainer[index] = number
        
    def find(self, number: int) -> int:
        matching_keys = [key for key, value in self._numbersToContainer.items() if value == number]
        return min(matching_keys) if matching_keys else -1
index = 1
obj = NumberContainers()
obj.change(index,number)
obj.change(1,1)
obj.change(2,1)
obj.change(3,2)







param_2 = obj.find(number)

print(param_2)
