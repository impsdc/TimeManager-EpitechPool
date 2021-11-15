import { useNotification } from "naive-ui";

export const useNotificationFactory = ({type, title, content}) => {
  const notification = useNotification()
  console.log(type)
  return () =>  notification[type]({
          content: 'What to say?',
          meta: "I don't know"
        })
}