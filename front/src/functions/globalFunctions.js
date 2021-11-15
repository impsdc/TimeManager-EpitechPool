Array.prototype.multiIndexOf = function (key, value) {
	var idxs = [];
	for (var i = this.length - 1; i >= 0; i--) {
		if (this[i][key] === value) {
			idxs.unshift(i);
		}
	}
	return idxs;
};
export default class GlobalActions {
	static listCleaner = (key, value, usersList) => {
		console.log("listCleaner");
		let array = usersList;
		let idxs = array.multiIndexOf(key, value);
		if (idxs.length > 0) {
			idxs.map((it) => array.splice(it, 1));
		}
		return array;
	};

	static arrayChanges = (oldArray, newArray) => {
		if (JSON.stringify(oldArray) === JSON.stringify(newArray)) {
			return true;
		}
		return false;
	};
}
