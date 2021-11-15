export default class Storage {
	static set = (key, value) => {
		localStorage.setItem(key, value);
		return;
	};

	static get = (key) => {
		return JSON.parse(localStorage.getItem(key));
	};

	static remove = (key) => {
		localStorage.removeItem(key);
		return;
	};
}
