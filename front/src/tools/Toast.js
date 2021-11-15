import { useNotification } from "naive-ui";

const useNotificationFactory = (type, title, content) => {
	const notification = useNotification();
	let count = 10;
	return () => {
		notification.create({
			type,
			title,
			content,
			duration: 10000,
			closable: true,
			onAfterEnter: () => {
				const minusCount = () => {
					count--;
					if (count > 0) {
						window.setTimeout(minusCount, 1000);
					}
				};
				window.setTimeout(minusCount, 1000);
			},
		});
	};
};

export default useNotificationFactory;
